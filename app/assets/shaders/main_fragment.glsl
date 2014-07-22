precision mediump float;

const int maxSpotLights = 4;

varying vec2 fragmentUv;
varying vec3 fragmentNormal;
varying vec4 fragmentPosition;

uniform sampler2D diffuseTexture;
uniform sampler2D specularTexture;
uniform sampler2D normalMap;
uniform vec3 ambientColor;
uniform vec4 cameraPosition;
uniform vec3 lightPositions[maxSpotLights];
uniform vec3 lightDirections[maxSpotLights];
uniform float spotAngles[maxSpotLights];
uniform float penumbraAngles[maxSpotLights];

const vec3 lightDiffuseColor = vec3(1.0, 1.0, 1.0);
const vec3 lightSpecularColor = vec3(0.4, 0.4, 0.4);
const float shininess = 5.0;

void main() {
  vec4 normalMapping = texture2D(normalMap, vec2(fragmentUv.s, fragmentUv.t));
  vec3 normal = normalize(fragmentNormal) * (normalMapping.rgb * 2.0 - 1.0);
  vec3 eyeDirection = normalize(vec3(cameraPosition - fragmentPosition));

  vec3 diffuseLight = ambientColor;
  vec3 specularLight = vec3(0.0);

  for (int i = 0; i < maxSpotLights; i++) {
    vec4 lightPosition = vec4(lightPositions[i], 1.0);
    vec3 lightDirection = lightDirections[i];
    float spotAngle = spotAngles[i];
    float penumbraAngle = penumbraAngles[i];

    vec3 lightToFragment = normalize(vec3(lightPosition - fragmentPosition));

    float attenuation;
    float currentAngle = max(0.0, dot(lightToFragment, lightDirection));
    float outerSpotAngle = cos(radians(spotAngle));
    if (currentAngle < outerSpotAngle) {
      attenuation = 0.0;
    } else {
      float innerSpotAngle = cos(radians(spotAngle - penumbraAngle));
      attenuation = (currentAngle - outerSpotAngle) / (innerSpotAngle - outerSpotAngle);
      attenuation = clamp(attenuation, 0.0, 1.0);
    }

    // Specular
    vec3 reflectionDirection = reflect(-lightToFragment, normal);
    float specularWeight = pow(max(dot(reflectionDirection, eyeDirection), 0.0), shininess);
    specularLight += attenuation * lightSpecularColor * specularWeight;

    // Diffuse
    float diffuseWeight = max(dot(normal, lightToFragment), 0.0);
    diffuseLight += attenuation * lightDiffuseColor * diffuseWeight;
  }

  vec4 materialDiffuseColor = texture2D(diffuseTexture, vec2(fragmentUv.s, fragmentUv.t));
  vec4 materialSpecularColor = texture2D(specularTexture, vec2(fragmentUv.s, fragmentUv.t));
  gl_FragColor = materialDiffuseColor * vec4(diffuseLight, 1.0)
    + materialSpecularColor * vec4(specularLight, 1.0);
}
