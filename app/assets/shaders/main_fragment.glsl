precision mediump float;

varying vec2 fragmentUv;
varying vec3 lightWeighting;

uniform sampler2D textureSampler;
uniform float alpha;

void main() {
  vec4 textureColor = texture2D(textureSampler, vec2(fragmentUv.s, fragmentUv.t));
  gl_FragColor = vec4(textureColor.rgb * lightWeighting, textureColor.a * alpha);
}
