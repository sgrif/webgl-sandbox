precision mediump float;

const int maxSpotLights = 4;

struct Light {
  vec4 position, direction;
  float spotAngle, penumbraAngle;
};

varying vec2 fragmentUv;
varying vec3 fragmentNormal;
varying vec4 fragmentPosition;

uniform sampler2D diffuseTexture;
uniform sampler2D specularTexture;
uniform sampler2D normalMap;
uniform vec3 ambientColor;
uniform vec4 cameraPosition;
uniform Light lights[maxSpotLights];

const vec3 lightDiffuseColor = vec3(0.5, 0.5, 0.5);
const vec3 lightSpecularColor = vec3(0.4, 0.4, 0.4);
const float shininess = 20.0;

void main() {
  vec4 normalMapping = texture2D(normalMap, fragmentUv);
  vec3 normal = normalize(fragmentNormal);
  vec3 eyeDirection = normalize(vec3(cameraPosition - fragmentPosition));

  vec3 diffuseLight = ambientColor;
  vec3 specularLight = vec3(0.0);

  for (int i = 0; i < maxSpotLights; i++) {
    Light light = lights[i];

    vec3 lightToFragment = normalize(vec3(light.position - fragmentPosition));

    float attenuation;
    float currentAngle = max(0.0, dot(lightToFragment, light.direction.xyz));
    float outerSpotAngle = cos(radians(light.spotAngle));
    if (currentAngle < outerSpotAngle) {
      attenuation = 0.0;
    } else {
      float innerSpotAngle = cos(radians(light.spotAngle - light.penumbraAngle));
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

  vec4 materialDiffuseColor = texture2D(diffuseTexture, fragmentUv);
  vec4 materialSpecularColor = texture2D(specularTexture, fragmentUv);
  gl_FragColor = materialDiffuseColor * vec4(diffuseLight, 1.0)
    + materialSpecularColor * vec4(specularLight, 1.0);
}
