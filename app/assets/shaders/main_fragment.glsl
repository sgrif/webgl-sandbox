precision mediump float;

varying vec2 fragmentUv;
varying vec3 lightWeighting;

uniform sampler2D textureSampler;

void main() {
  vec4 textureColor = texture2D(textureSampler, vec2(fragmentUv.s, fragmentUv.t));
  gl_FragColor = textureColor * vec4(lightWeighting, 1.0);
}
