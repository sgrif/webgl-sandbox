attribute vec3 vertexCoord;
attribute vec2 vertexUv;
attribute vec3 vertexNormal;

varying vec2 fragmentUv;
varying vec3 fragmentNormal;
varying vec4 mvPosition;

uniform mat4 m, v, p;
uniform mat3 normalMatrix;

void main() {
  mat4 mv = v * m;
  mvPosition = mv * vec4(vertexCoord, 1);
  gl_Position = p * mvPosition;
  fragmentUv = vertexUv;
  fragmentNormal = normalMatrix * vertexNormal;
}
