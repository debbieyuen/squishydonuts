﻿/******************************************************************************/
/*
  Project   - MudBun
  Publisher - Long Bunny Labs
              http://LongBunnyLabs.com
  Author    - Ming-Lun "Allen" Chou
              http://AllenChou.net
*/
/******************************************************************************/

#ifndef MUDBUN_QUATERNION
#define MUDBUN_QUATERNION

#include "MathConst.cginc"
#include "Vector.cginc"

#define kQuatIdentity (float4(0.0f, 0.0f, 0.0f, 1.0f))

float4 quat_conj(float4 q)
{
  return float4(-q.xyz, q.w);
}

float4 quat_inv(float4 q)
{
  return quat_conj(q);
}

// q must be unit quaternion
float4 quat_pow(float4 q, float p)
{
  float r = length(q.xyz);
  if (r < kEpsilon)
    return kQuatIdentity;

  float t = p * atan2(q.w, r);

  return float4(sin(t) * q.xyz / r, cos(t));
}

float3 quat_rot(float4 q, float3 v)
{
  return
    dot(q.xyz, v) * q.xyz
    + q.w * q.w * v
    + 2.0 * q.w * cross(q.xyz, v)
    - cross(cross(q.xyz, v), q.xyz);
}

float4 quat_axis_angle(float3 v, float a)
{
  float h = 0.5 * a;
  return float4(sin(h) * normalize(v), cos(h));
}

float4 quat_from_to(float3 from, float3 to)
{
  float3 c = cross(from, to);
  float cc = dot(c, c);

  if (cc < kEpsilon)
    return kQuatIdentity;

  float3 axis = c / sqrt(cc);
  float angle = acos(clamp(dot(from, to), -1.0f, 1.0f));
  return quat_axis_angle(axis, angle);
}

float3 quat_get_axis(float4 q)
{
  float d = dot(q.xyz, q.xyz);
  return 
    d > kEpsilon 
    ? q.xyz / sqrt(d)
    : float3(0.0f, 0.0f, 1.0f);
}

float3 quat_get_angle(float4 q)
{
  return 2.0f * acos(clamp(q.w, -1.0f, 1.0f));
}

float4 quat_mul(float4 q1, float4 q2)
{
  return 
    float4
    (
      q1.w * q2.xyz + q2.w * q1.xyz + cross(q1.xyz, q2.xyz), 
      q1.w * q2.w - dot(q1.xyz, q2.xyz)
    );
}

float4 quat_mat(float3x3 m)
{
  float tr = m._m00 + m._m11 + m._m22;
  if (tr > 0.0f) {
    float s = sqrt(tr + 1.0f) * 2.0f;
    float sInv = 1.0f / s;
    return
      float4
      (
        (m._m21 - m._m12) * sInv, 
        (m._m02 - m._m20) * sInv, 
        (m._m10 - m._m01) * sInv, 
        0.25 * s
      );
  }
  else if ((m._m00 > m._m11) && (m._m00 > m._m22))
  {
    float s = sqrt(1.0f + m._m00 - m._m11 - m._m22) * 2.0f;
    float sInv = 1.0f / s;
    return
      float4
      (
        0.25f * s, 
        (m._m01 + m._m10) * sInv, 
        (m._m02 + m._m20) * sInv, 
        (m._m21 - m._m12) * sInv
      );
  }
  else if (m._m11 > m._m22)
  {
    float s = sqrt(1.0f + m._m11 - m._m00 - m._m22) * 2.0f;
    float sInv = 1.0f / s;
    return
      float4
      (
        (m._m01 + m._m10) * sInv, 
        0.25 * s, 
        (m._m12 + m._m21) * sInv, 
        (m._m02 - m._m20) * sInv
      );
  }
  else {
    float s = sqrt(1.0f + m._m22 - m._m00 - m._m11) * 2.0f;
    float sInv = 1.0f / s;
    return
      float4
      (
        (m._m02 + m._m20) * sInv, 
        (m._m12 + m._m21) * sInv, 
        0.25 * s, 
        (m._m10 - m._m01) * sInv
      );
  }
}

float4 quat_look_at(float3 dir, float3 up)
{
  return quat_mat(mat_look_at(dir, up));
}

// order: ZXY
float4 quat_euler(float3 rot)
{
  return
    quat_mul
    (
      quat_mul
      (
        quat_axis_angle(kUnitY, rot.x),
        quat_axis_angle(kUnitX, rot.y)
      ),
      quat_axis_angle(kUnitZ, rot.z)
    );
}

float4 slerp(float4 a, float4 b, float t)
{
  float d = dot(normalize(a), normalize(b));
  if (d > kEpsilonComp)
  {
    return lerp(a, b, t);
  }

  float r = acos(clamp(d, -1.0f, 1.0f));
  return (sin((1.0 - t) * r) * a + sin(t * r) * b) / sin(r);
}

float4 nlerp(float4 a, float b, float t)
{
  return normalize(lerp(a, b, t));
}

#endif
