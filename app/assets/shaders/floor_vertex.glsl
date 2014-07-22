attribute vec3 vertexCoord;
attribute vec2 vertexUv;
attribute vec3 vertexNormal;

varying vec2 fragmentUv;
varying vec3 fragmentNormal;
varying vec4 fragmentPosition;

uniform mat4 m, v, p;
uniform mat3 normalMatrix;

void main() {
  fragmentPosition = m * vec4(vertexCoord, 1.0);
  gl_Position = p * v * fragmentPosition;
  fragmentUv = vertexUv;
  fragmentNormal = normalMatrix * vertexNormal;
}
