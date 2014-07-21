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

uniform mat4 bones[154];

void main() {
  vec4 skinnedVertex = vec4(0.0);
  vec4 skinnedNormal = vec4(0.0);

  vec4 vertex = vec4(vertexCoord, 1.0);
  vec4 normal = vec4(vertexNormal, 0.0);

  mat4 boneMatX = bones[int(vertexSkinIndices.x)];
  mat4 boneMatY = bones[int(vertexSkinIndices.y)];
  mat4 boneMatZ = bones[int(vertexSkinIndices.z)];
  mat4 boneMatW = bones[int(vertexSkinIndices.w)];

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
