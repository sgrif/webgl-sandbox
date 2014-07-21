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
  vec4 skinnedVertex;
  vec4 skinnedNormal;

  vec4 vertex = vec4(vertexCoord, 1.0);
  vec4 normal = vec4(vertexNormal, 0.0);

  int index = int(vertexSkinIndices.x);
  skinnedVertex = bones[index] * vertex * vertexSkinWeights.x;
  skinnedNormal = bones[index] * normal * vertexSkinWeights.x;

  index = int(vertexSkinIndices.y);
  skinnedVertex += bones[index] * vertex * vertexSkinWeights.y;
  skinnedNormal += bones[index] * normal * vertexSkinWeights.y;

  index = int(vertexSkinIndices.z);
  skinnedVertex += bones[index] * vertex * vertexSkinWeights.z;
  skinnedNormal += bones[index] * normal * vertexSkinWeights.z;

  index = int(vertexSkinIndices.w);
  skinnedVertex += bones[index] * vertex * vertexSkinWeights.w;
  skinnedNormal += bones[index] * normal * vertexSkinWeights.w;

  fragmentPosition = m * skinnedVertex;
  gl_Position = p * v * fragmentPosition;
  fragmentUv = vertexUv;
  fragmentNormal = normalMatrix * vec3(skinnedNormal);
}
