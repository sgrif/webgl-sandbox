attribute vec3 vertexCoord;
attribute vec2 vertexUv;
attribute vec3 vertexNormal;

varying vec2 fragmentUv;
varying vec3 lightWeighting;

uniform mat4 m, v, p;
uniform mat3 normalMatrix;
uniform vec4 lightPosition;
uniform vec3 ambientColor;

const vec3 lightDiffuseColor = vec3(1.0, 1.0, 1.0);

void main() {
  mat4 mvp = p * v * m;
  gl_Position = mvp * vec4(vertexCoord, 1);

  vec3 normalDirection = normalize(normalMatrix * vertexNormal);
  vec3 lightDirection = normalize(vec3(lightPosition));
  float lightDiffuseWeight = max(0.0, dot(normalDirection, lightDirection));

  lightWeighting = ambientColor + lightDiffuseColor * lightDiffuseWeight;
  fragmentUv = vertexUv;
}
