precision mediump float;

varying vec2 fragmentUv;

uniform sampler2D textureSampler;

void main() {
  gl_FragColor = texture2D(textureSampler, vec2(fragmentUv.s, fragmentUv.t));
}
