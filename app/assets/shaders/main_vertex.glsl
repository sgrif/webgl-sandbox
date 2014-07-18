attribute vec3 vertexCoord;
attribute vec3 vertexColor;

varying vec3 fragmentColor;

void main() {
  gl_Position = vec4(vertexCoord, 1);
  fragmentColor = vertexColor;
}
