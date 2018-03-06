var VSHADER_SOURCE=`
attribute vec4 a_point;
uniform mat4 u_matrix;
void main(){
    gl_Position = u_matrix * a_point;
}
`;
var FSHADER_SOURCE=`
precision mediump float;
void main(){
    gl_FragColor=vec4(1.0, 0.0, 0.0, 1.0);
}
`;
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

    var rotate = 45;
    var tick = function(){
        rotate += 1;
        rotate %= 360;
        matrix.setIdentity();
        matrix.rotate(rotate, 0, 0, 1);
        gl.uniformMatrix4fv(u_matrix, false, matrix.elements);

        gl.clear(gl.COLOR_BUFFER_BIT);

        gl.drawArrays(gl.TRIANGLE_STRIP, 0, n);
        window.requestAnimationFrame(tick);
    };
    tick();
}


function initVertexBuffer(gl){
    var buffer = gl.createBuffer();
    if(!buffer){
        console.log("failed to create buffer object");
        return -1;
    }
    var data = new Float32Array([
        -0.5, 0.5,  -0.5, -0.5 , 0.5, 0.5, 0.5, -0.5,
    ]);

    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW);

    var a_point = gl.getAttribLocation(gl.program, "a_point");
    gl.vertexAttribPointer(a_point, 2, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(a_point);

    return 4;
}