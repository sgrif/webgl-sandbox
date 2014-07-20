precision mediump float;

varying vec2 fragmentUv;
varying vec3 fragmentNormal;
varying vec4 fragmentPosition;

uniform sampler2D textureSampler;
uniform vec4 lightPosition;
uniform vec3 ambientColor;
uniform vec4 cameraPosition;
uniform float spotAngle;
uniform float penumbraAngle;

const vec3 lightDiffuseColor = vec3(1.0, 1.0, 1.0);
const vec3 lightSpecularColor = vec3(0.4, 0.4, 0.4);
const float shininess = 5.0;

void main() {
  vec3 lightDirection = normalize(vec3(lightPosition - fragmentPosition));
  vec3 normal = normalize(fragmentNormal);

  float attenuation;
  float currentAngle = max(0.0, dot(lightDirection, vec3(0.0, 0.0, 1.0)));
  float outerSpotAngle = cos(radians(spotAngle));
  if (currentAngle < outerSpotAngle) {
    attenuation = 0.0;
  } else {
    float innerSpotAngle = cos(radians(spotAngle - penumbraAngle));
    attenuation = (currentAngle - outerSpotAngle) / (innerSpotAngle - outerSpotAngle);
    attenuation = clamp(attenuation, 0.0, 1.0);
  }

  // Specular
  vec3 eyeDirection = normalize(vec3(cameraPosition - fragmentPosition));
  vec3 reflectionDirection = reflect(-lightDirection, normal);
  float specularWeight = pow(max(dot(reflectionDirection, eyeDirection), 0.0), shininess);
  vec3 specularLight = attenuation * lightSpecularColor * specularWeight;

  // Diffuse
  float diffuseWeight = attenuation * max(dot(normal, lightDirection), 0.0);

  // Apply lighting
  vec3 diffuseLight = ambientColor
    + lightDiffuseColor * diffuseWeight;

  vec4 textureColor = texture2D(textureSampler, vec2(fragmentUv.s, fragmentUv.t));
  gl_FragColor = textureColor * vec4(diffuseLight, 1.0) + vec4(specularLight, 1.0);
}
