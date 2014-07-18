attribute vec3 vertexCoord;
attribute vec3 vertexColor;

varying vec3 fragmentColor;

uniform mat4 transformation;

void main() {
  gl_Position = transformation * vec4(vertexCoord, 1);

  fragmentColor = vertexColor;
}
