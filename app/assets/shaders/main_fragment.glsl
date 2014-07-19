precision mediump float;

varying vec2 fragmentUv;
varying vec4 diffuseColor;

uniform sampler2D textureSampler;

void main() {
  vec4 textureColor = texture2D(textureSampler, vec2(fragmentUv.s, fragmentUv.t));
  gl_FragColor = textureColor * diffuseColor;
}
