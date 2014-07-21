attribute vec3 vertexCoord;
attribute vec2 vertexUv;
attribute vec3 vertexNormal;
attribute vec4 vertexSkinWeights;
attribute vec4 vertexSkinIndices;

varying vec2 fragmentUv;
varying vec3 fragmentNormal;
varying vec4 fragmentPosition;

uniform mat4 m, v, p;
uniform mat3 normalMatrix;

uniform sampler2D bones;
uniform int boneTextureWidth;
uniform int boneTextureHeight;

mat4 getBoneMatrix(const in float i) {
  float j = i * 4.0;
  float x = mod(j, float(boneTextureWidth));
  float y = floor(j / float(boneTextureWidth));

  float dx = 1.0 / float(boneTextureWidth);
  float dy = 1.0 / float(boneTextureHeight);

  y = dy * (y + 0.5);

  vec4 v1 = texture2D(bones, vec2(dx * (x + 0.5), y));
  vec4 v2 = texture2D(bones, vec2(dx * (x + 1.5), y));
  vec4 v3 = texture2D(bones, vec2(dx * (x + 2.5), y));
  vec4 v4 = texture2D(bones, vec2(dx * (x + 3.5), y));

  return mat4(v1, v2, v3, v4);
}

void main() {
  vec4 skinnedVertex = vec4(0.0);
  vec4 skinnedNormal = vec4(0.0);

  vec4 vertex = vec4(vertexCoord, 1.0);
  vec4 normal = vec4(vertexNormal, 0.0);

  mat4 boneMatX = getBoneMatrix(vertexSkinIndices.x);
  mat4 boneMatY = getBoneMatrix(vertexSkinIndices.y);
  mat4 boneMatZ = getBoneMatrix(vertexSkinIndices.z);
  mat4 boneMatW = getBoneMatrix(vertexSkinIndices.w);

  skinnedVertex += boneMatX * vertex * vertexSkinWeights.x;
  skinnedVertex += boneMatY * vertex * vertexSkinWeights.y;
  skinnedVertex += boneMatZ * vertex * vertexSkinWeights.z;
  skinnedVertex += boneMatW * vertex * vertexSkinWeights.w;

  skinnedNormal += boneMatX * normal * vertexSkinWeights.x;
  skinnedNormal += boneMatY * normal * vertexSkinWeights.y;
  skinnedNormal += boneMatZ * normal * vertexSkinWeights.z;
  skinnedNormal += boneMatW * normal * vertexSkinWeights.w;

  fragmentPosition = m * skinnedVertex;
  gl_Position = p * v * fragmentPosition;
  fragmentUv = vertexUv;
  fragmentNormal = normalMatrix * vec3(skinnedNormal);
}
