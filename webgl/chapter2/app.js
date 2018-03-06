var VSHADER_SOURCE=`
attribute vec4 a_point;
uniform mat4 u_matrix;
attribute vec2 a_textureCoord;
varying vec2 v_textureCoord;
void main(){
    gl_Position = u_matrix * a_point;
    v_textureCoord = a_textureCoord;
}
`;
var FSHADER_SOURCE=`
precision mediump float;
varying vec2 v_textureCoord;
uniform sampler2D u_sampler;
uniform sampler2D u_sampler_1;
void main(){
    gl_FragColor=texture2D(u_sampler, v_textureCoord) + texture2D(u_sampler_1, v_textureCoord);
}
`;

var img_loaded = 0;
function main(){
    var canvas = document.getElementById("canvas");
    if(!canvas){
        console.log("failed to retrieve the <canvas> element");
        return false;
    }

    gl = getWebGLContext(canvas);
    if(!gl){
        console.log("failed to get the rendering context for webgl");
        return;
    }

    if(!initShaders(gl, VSHADER_SOURCE, FSHADER_SOURCE)){
        console.log("failed to initialize shaders");
        return;
    }

    var n = initVertexBuffer(gl);

    var u_matrix = gl.getUniformLocation(gl.program, "u_matrix");
    if(!u_matrix){
        console.log("failed to get the storage location of u_matrix");
        return;
    }

    gl.clearColor(0.0, 0.0,0.0, 1.0);
    var matrix = new Matrix4();

    // var u_width = gl.getUniformLocation(gl.program, "u_width");
    // gl.uniform1f(u_width, gl.drawingBufferWidth);

    // var u_height = gl.getUniformLocation(gl.program, "u_height");
    // gl.uniform1f(u_height, gl.drawingBufferHeight);

    if(!initTextures(gl, n)){
        return;
    }

    var rotate = 45;
    var tick = function(){
        if(img_loaded >= 2){
            rotate = draw(gl, u_matrix, matrix, rotate, n);
        }
        window.requestAnimationFrame(tick);
    };
    tick();
}

function draw(gl, u_matrix, matrix, rotate, n){
    rotate += 1;
    rotate %= 360;
    matrix.setIdentity();
    matrix.rotate(rotate, 0, 0, 1);
    gl.uniformMatrix4fv(u_matrix, false, matrix.elements);

    gl.clear(gl.COLOR_BUFFER_BIT);

    gl.drawArrays(gl.TRIANGLE_STRIP, 0, n);
    return rotate;
}

function initVertexBuffer(gl){
    var buffer = gl.createBuffer();
    if(!buffer){
        console.log("failed to create buffer object");
        return -1;
    }
    var n = 4;
    var data = new Float32Array([
        -0.5, 0.5, 0.0, 1.0,
        0.5, 0.5, 1.0, 1.0,
        0.5, -0.5, 1.0, 0.0,
        -0.5, -0.5, 0.0, 0.0,
    ]);

    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW);

    var fSize = data.BYTES_PER_ELEMENT;

    var a_point = gl.getAttribLocation(gl.program, "a_point");
    gl.vertexAttribPointer(a_point, 2, gl.FLOAT, false, fSize * 4, 0);
    gl.enableVertexAttribArray(a_point);

    var a_textureCoord = gl.getAttribLocation(gl.program, "a_textureCoord");
    gl.vertexAttribPointer(a_textureCoord, 2, gl.FLOAT, false, fSize * 4, fSize * 2);
    gl.enableVertexAttribArray(a_textureCoord);

    return 3;
}


function initTextures(gl, n){
    var texture = gl.createTexture();
    if(!texture){
        console.log("failed to create texture");
        return false;
    }
    var u_sampler = gl.getUniformLocation(gl.program, "u_sampler");
    if(!u_sampler){
        console.log("failed to get the storage of u_sampler");
        return false;
    }

    var u_sampler_1 = gl.getUniformLocation(gl.program, "u_sampler_1");

    var image = new Image();
    image.onload = function(){
        loadTexture(gl, n, u_sampler, texture, image);
    };
    image.src = "../resources/sky.jpg";
    var image1 = new Image();
    image1.onload = function(){
        loadTexture(gl, n, u_sampler_1, texture, image1);
    };
    image1.src = "../resources/circle.gif";

    // image.crossOrigin = "anonymous";
    // image.src = "http://rodger.global-linguist.com/webgl/resources/sky.jpg";
    return true;
}

function loadTexture(gl, n, u_sampler, texture, image){
    var textId, unit;
    unit = img_loaded;
    if(img_loaded === 0){
        textId = gl.TEXTURE0;
    } else {
        textId = gl.TEXTURE1;
    }
    gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, 1);
    gl.activeTexture(textId);
    gl.bindTexture(gl.TEXTURE_2D, texture);

    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGB, gl.RGB, gl.UNSIGNED_BYTE, image);
    gl.uniform1i(u_sampler, unit);

    img_loaded ++;
}
