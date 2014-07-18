attribute vec2 vertexCoord;
attribute vec3 vertexColor;

varying vec3 fragmentColor;

uniform vec2 resolution;

void main() {
  // convert from pixels to -1.0 to 1.0 based on resolution
  vec2 clipSpace = (vertexCoord / resolution) * 2.0 - 1.0;

  gl_Position = vec4(clipSpace, 0, 1);
  fragmentColor = vertexColor;
}
