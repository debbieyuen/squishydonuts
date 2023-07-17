﻿/******************************************************************************/
/*
  Project   - MudBun
  Publisher - Long Bunny Labs
              http://LongBunnyLabs.com
  Author    - Ming-Lun "Allen" Chou
              http://AllenChou.net
*/
/******************************************************************************/

Shader "MudBun/Mud Mesh Multi-Textured (Built-In RP)"
{
  Properties
  {
    _AlphaCutoutThreshold("Alpha Cutout Threshold", Range(0.0, 1.0)) = 0.5
    _Dithering("Dithering", Range(0.0, 1.0)) = 0.0
    _DitherTexture("Dither Texture", 2D) = "black"
    _DitherTextureSize("Dither TextureSize", Int) = 256
    [Toggle] _RandomDither("Random Dither", Int) = 0

    [Toggle] _UseTex0("Use Texture 0", Int) = 0
      _MainTex("Albedo 0", 2D) = "white" {}
      [Toggle] _MainTexX("     X Axis Projection", Int) = 1
      [Toggle] _MainTexY("     Y Axis Projection", Int) = 1
      [Toggle] _MainTexZ("     Z Axis Projection", Int) = 1
    [Toggle] _UseTex1("Use Texture 1", Int) = 0
      _Tex1("  Albedo 1", 2D) = "white" {}
      [Toggle] _Tex1X("     X Axis Projection", Int) = 1
      [Toggle] _Tex1Y("     Y Axis Projection", Int) = 1
      [Toggle] _Tex1Z("     Z Axis Projection", Int) = 1
    [Toggle] _UseTex2("Use Texture 2", Int) = 0
      _Tex2("  Albedo 2", 2D) = "white" {}
      [Toggle] _Tex2X("     X Axis Projection", Int) = 1
      [Toggle] _Tex2Y("     Y Axis Projection", Int) = 1
      [Toggle] _Tex2Z("     Z Axis Projection", Int) = 1
    [Toggle] _UseTex3("Use Texture 3", Int) = 0
      _Tex3("  Albedo 3", 2D) = "white" {}
      [Toggle] _Tex3X("     X Axis Projection", Int) = 1
      [Toggle] _Tex3Y("     Y Axis Projection", Int) = 1
      [Toggle] _Tex3Z("     Z Axis Projection", Int) = 1
    [Toggle] _UseNorm0("Use Normal Map 0", Int) = 0
      _MainNorm("Albedo 0", 2D) = "white" {}
      [Toggle] _MainNormX("     X Axis Projection", Int) = 1
      [Toggle] _MainNormY("     Y Axis Projection", Int) = 1
      [Toggle] _MainNormZ("     Z Axis Projection", Int) = 1
    [Toggle] _UseNorm1("Use Normal Map 1", Int) = 0
      _Norm1("  Albedo 1", 2D) = "white" {}
      [Toggle] _Norm1X("     X Axis Projection", Int) = 1
      [Toggle] _Norm1Y("     Y Axis Projection", Int) = 1
      [Toggle] _Norm1Z("     Z Axis Projection", Int) = 1
    [Toggle] _UseNorm2("Use Normal Map 2", Int) = 0
      _Norm2("  Albedo 2", 2D) = "white" {}
      [Toggle] _Norm2X("     X Axis Projection", Int) = 1
      [Toggle] _Norm2Y("     Y Axis Projection", Int) = 1
      [Toggle] _Norm2Z("     Z Axis Projection", Int) = 1
    [Toggle] _UseNorm3("Use Normal Map 3", Int) = 0
      _Norm3("  Albedo 3", 2D) = "white" {}
      [Toggle] _Norm3X("     X Axis Projection", Int) = 1
      [Toggle] _Norm3Y("     Y Axis Projection", Int) = 1
      [Toggle] _Norm3Z("     Z Axis Projection", Int) = 1
  }
  SubShader
  {
    ZWrite On
    Cull Back
    Tags { "Queue" = "Geometry" "RenderType" = "Opaque" }

    CGPROGRAM

    #define MUDBUN_BUILT_IN_RP
    #pragma multi_compile_instancing
    #pragma multi_compile _ MUDBUN_PROCEDURAL
    #pragma surface surf Standard vertex:vert addshadow fullforwardshadows
    #pragma target 3.5

    #include "UnityCG.cginc"

    #include "../../../Shader/Render/ShaderCommon.cginc"

    #if MUDBUN_VALID
      #include "../../../Shader/Render/MeshCommon.cginc"
    #endif

    void vert(inout Vertex i, out Input o)
    {
      UNITY_INITIALIZE_OUTPUT(Input, o);

      #if MUDBUN_VALID
        float sdfValue;
        float3 tangentWs;
        float3 tangentLs;
        float3 normal2dLs;
        float3 normal2dWs;
        mudbun_mesh_vert(i.id, i.vertex, o.localPos, i.normal, o.localNorm, tangentWs, tangentLs, i.color, o.emissionHash, o.metallicSmoothness, o.texWeight, sdfValue, normal2dLs, normal2dWs);
        i.tangent = o.tangent = float4(tangentWs, 0.0f);
      #endif
    }

    void surf(Input i, inout SurfaceOutputStandard o)
    {
      float4 color = 1.0f;

      float4 texColor = 0.0f;
      float totalTexWeight = 0.0f;

      float4 normColor = 0.0f;
      float totalNormWeight = 0.0f;

      float3 triWeight = abs(i.localNorm);

      if (_UseTex0)
      {
        texColor += tex2D_triplanar(_MainTex, _MainTex_ST, triWeight, i.localPos, _MainTexX, _MainTexY, _MainTexZ) * i.texWeight.x;
        totalTexWeight += i.texWeight.x;
      }

      if (_UseTex1)
      {
        texColor += tex2D_triplanar(_Tex1, _Tex1_ST, triWeight, i.localPos, _Tex1X, _Tex1Y, _Tex1Z) * i.texWeight.y;
        totalTexWeight += i.texWeight.y;
      }

      if (_UseTex2)
      {
        texColor += tex2D_triplanar(_Tex2, _Tex2_ST, triWeight, i.localPos, _Tex2X, _Tex2Y, _Tex2Z) * i.texWeight.z;
        totalTexWeight += i.texWeight.z;
      }

      if (_UseTex3)
      {
        texColor += tex2D_triplanar(_Tex3, _Tex3_ST, triWeight, i.localPos, _Tex3X, _Tex3Y, _Tex3Z) * i.texWeight.w;
        totalTexWeight += i.texWeight.w;
      }

      if (totalTexWeight > 0.0f)
      {
        color = texColor / totalTexWeight;
      }

      if (_UseNorm0)
      {
        normColor += tex2D_triplanar(_MainNorm, _MainNorm_ST, triWeight, i.localPos, _MainNormX, _MainNormY, _MainNormZ) * i.texWeight.x;
        totalNormWeight += i.texWeight.x;
      }

      if (_UseNorm1)
      {
        normColor += tex2D_triplanar(_Norm1, _Norm1_ST, triWeight, i.localPos, _Norm1X, _Norm1Y, _Norm1Z) * i.texWeight.y;
        totalNormWeight += i.texWeight.y;
      }

      if (_UseNorm2)
      {
        normColor += tex2D_triplanar(_Norm2, _Norm2_ST, triWeight, i.localPos, _Norm2X, _Norm2Y, _Norm2Z) * i.texWeight.z;
        totalNormWeight += i.texWeight.z;
      }

      if (_UseNorm3)
      {
        normColor += tex2D_triplanar(_Norm3, _Norm3_ST, triWeight, i.localPos, _Norm3X, _Norm3Y, _Norm3Z) * i.texWeight.w;
        totalNormWeight += i.texWeight.w;
      }

      if (totalNormWeight > 0.0f)
      {
        o.Normal = UnpackNormal(normColor / totalNormWeight);
      }

      float3 albedo = i.color.rgb * _Color.rgb * color.rgb;
      float alpha = i.color.a * _Color.a * color.a;
      float alphaThreshold;
      float2 screenPos = i.screenPos.xy * _ScreenParams.xy / (i.screenPos.w + kEpsilon);
      computeOpaqueTransparency(screenPos, i.localPos, i.emissionHash.a, _DitherTexture, _DitherTextureSize, _RandomDither > 0, _AlphaCutoutThreshold, _Dithering, alpha, alphaThreshold);
      clip(alpha - alphaThreshold);

      o.Albedo = albedo;
      o.Emission = float4(i.emissionHash.rgb, 1.0f)  * _Emission;
      o.Metallic = i.metallicSmoothness.x * _Metallic;
      o.Smoothness = i.metallicSmoothness.y * _Smoothness;
    }

    ENDCG
  }

  CustomEditor "MudBun.MudMeshMultiTexturedMaterialEditor"
}
