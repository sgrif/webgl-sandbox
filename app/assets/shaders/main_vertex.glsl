attribute vec3 vertexCoord;
attribute vec2 vertexUv;
attribute vec3 vertexNormal;

varying vec2 fragmentUv;
varying vec4 diffuseColor;

uniform mat4 mvp;

const vec4 lightPosition = vec4(-1.0, 1.0, -1.0, 0.0);
const vec4 lightDiffuseColor = vec4(1.0, 1.0, 1.0, 1.0);

const vec4 materialDiffuseColor = vec4(1.0, 0.8, 0.8, 1.0);

void main() {
  gl_Position = mvp * vec4(vertexCoord, 1);

  vec3 adjustedLightPosition = normalize(vec3(lightPosition)) * vec3(-1.0, -1.0, -1.0);

  fragmentUv = vertexUv;
  diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
}
