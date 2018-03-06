var VSHADER_SOURCE=`
attribute vec4 a_point;
attribute float a_size;
void main(){
    gl_Position = a_point;
    gl_PointSize= a_size;
}
`;
var FSHADER_SOURCE=`
precision mediump float;
uniform vec4 u_color;
void main(){
    gl_FragColor=u_color;
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

    var a_point = gl.getAttribLocation(gl.program, "a_point");
    if(a_point < 0){
        console.log("failed to get the storage location of a_point");
        return;
    }

    var a_size = gl.getAttribLocation(gl.program, "a_size");
    if(a_size < 0){
        console.log("failed to get the storage location of a_size");
        return;
    }
    gl.vertexAttrib1f(a_size, 5.0);

    var u_color = gl.getUniformLocation(gl.program, "u_color");
    if(!u_color){
        console.log("failed to get the storage location of u_color");
        return;
    }

    window.onmousedown = function(e){
        onClick(e, gl, canvas, a_point, u_color);
    }
    gl.clearColor(0.0, 0.0,0.0, 1.0);
    gl.clear(gl.COLOR_BUFFER_BIT);

    drawPoints(gl, a_point, u_color);
}

var gl_points = [];
var gl_colors = [];
function onClick(ev, gl, canvas, a_point, u_color){
    var x = ev.clientX;
    var y = ev.clientY;
    var rect = ev.target.getBoundingClientRect();

    x = ((x - rect.left) - canvas.width / 2) / (canvas.width / 2);
    y = (canvas.height / 2 - (y - rect.top)) / (canvas.height / 2);

    gl_points.push([x, y]);

    var r = Math.abs(x);
    var g = Math.abs(y);
    gl_colors.push([r, g]);

    drawPoints(gl, a_point, u_color);
}

function drawPoints(gl, a_point, u_color){
    gl.clearColor(0.0, 0.0,0.0, 1.0);
    gl.clear(gl.COLOR_BUFFER_BIT);

    var l = gl_points.length;
    for(let i = 0; i < l; i++){
        var point = gl_points[i];
        var color = gl_colors[i];
        gl.vertexAttrib3f(a_point, point[0], point[1], 0.0);
        gl.uniform4f(u_color, color[0], color[1], 1.0, 1.0);

        gl.drawArrays(gl.POINTS, 0, 1);
    }
}
