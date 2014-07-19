attribute vec3 vertexCoord;
attribute vec2 vertexUv;

varying vec2 fragmentUv;

uniform mat4 mvp;

void main() {
  gl_Position = mvp * vec4(vertexCoord, 1);

  fragmentUv = vertexUv;
}
