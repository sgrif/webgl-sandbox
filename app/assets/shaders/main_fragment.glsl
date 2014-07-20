precision mediump float;

varying vec2 fragmentUv;
varying vec3 fragmentNormal;
varying vec4 mvPosition;

uniform sampler2D textureSampler;
uniform vec4 lightPosition;
uniform vec3 ambientColor;

const vec3 pointLightDiffuseColor = vec3(1.0, 1.0, 1.0);

void main() {
  vec3 lightDirection = normalize(vec3(lightPosition - mvPosition));
  float directionalLight = max(dot(normalize(fragmentNormal), lightDirection), 0.0);
  vec3 lightWeighting = ambientColor + pointLightDiffuseColor * directionalLight;

  vec4 textureColor = texture2D(textureSampler, vec2(fragmentUv.s, fragmentUv.t));
  gl_FragColor = textureColor * vec4(lightWeighting, 1.0);
}
