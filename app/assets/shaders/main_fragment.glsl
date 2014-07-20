precision mediump float;

varying vec2 fragmentUv;
varying vec3 fragmentNormal;
varying vec4 mvPosition;

uniform sampler2D textureSampler;
uniform vec4 lightPosition;
uniform vec3 ambientColor;

const vec3 lightDiffuseColor = vec3(1.0, 1.0, 1.0);
const vec3 lightSpecularColor = vec3(0.4, 0.4, 0.4);
const float shininess = 5.0;

void main() {
  vec3 lightDirection = normalize(vec3(lightPosition - mvPosition));
  vec3 normal = normalize(fragmentNormal);

  // Specular
  vec3 eyeDirection = normalize(vec3(mvPosition));
  vec3 reflectionDirection = reflect(lightDirection, normal);
  float specularWeight = pow(max(dot(reflectionDirection, eyeDirection), 0.0), shininess);
  vec3 specularLight = vec3(0.0, 0.0, 0.0);

  if (dot(lightDirection, normal) > 0.0) {
    specularLight = lightSpecularColor * specularWeight;
  }

  // Diffuse
  float diffuseWeight = max(dot(normal, lightDirection), 0.0);

  // Apply lighting
  vec3 lightWeight = ambientColor
    + lightDiffuseColor * diffuseWeight;

  vec4 textureColor = texture2D(textureSampler, vec2(fragmentUv.s, fragmentUv.t));
  gl_FragColor = textureColor * vec4(lightWeight, 1.0) + vec4(specularLight, 1.0);
}
