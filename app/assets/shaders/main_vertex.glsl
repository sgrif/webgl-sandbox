attribute vec3 vertexCoord;
attribute vec3 vertexColor;

varying vec3 fragmentColor;

uniform mat4 mvp;

void main() {
  gl_Position = mvp * vec4(vertexCoord, 1);

  fragmentColor = vertexColor;
}
