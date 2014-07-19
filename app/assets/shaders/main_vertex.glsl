attribute vec3 vertexCoord;
attribute vec2 vertexUv;
attribute vec3 vertexNormal;

varying vec2 fragmentUv;
varying vec4 diffuseColor;

uniform mat4 m, v, p;
uniform mat3 normalMatrix;
uniform vec4 lightPosition;

const vec3 lightDiffuseColor = vec3(1.0, 1.0, 1.0);
const vec3 ambientColor = vec3(0.2, 0.2, 0.2);

void main() {
  mat4 mvp = p * v * m;
  gl_Position = mvp * vec4(vertexCoord, 1);

  vec3 normalDirection = normalize(normalMatrix * vertexNormal);
  vec3 lightDirection = normalize(vec3(lightPosition));
  float lightDiffuseWeight = max(0.0, dot(normalDirection, lightDirection));

  diffuseColor = vec4(ambientColor + lightDiffuseColor * lightDiffuseWeight, 1.0);
  fragmentUv = vertexUv;
}
