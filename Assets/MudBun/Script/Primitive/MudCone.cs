﻿/******************************************************************************/
/*
  Project   - MudBun
  Publisher - Long Bunny Labs
              http://LongBunnyLabs.com
  Author    - Ming-Lun "Allen" Chou
              http://AllenChou.net
*/
/******************************************************************************/

using System.Collections.Generic;

using Unity.Collections;
using UnityEngine;

namespace MudBun
{
  public class MudCone : MudSolid
  {
    [SerializeField] private float m_radius = 0.5f;
    public float Radius { get => m_radius; set { m_radius = value; MarkDirty(); } }

    [SerializeField] private float m_round = 0.0f;
    public float Round { get => m_round; set { m_round = value; MarkDirty(); } }

    [Range(-1.0f, 1.0f)] public float PivotShift = 0.0f;
    public Vector3 PivotShiftOffset => -0.5f * transform.up * PivotShift * transform.localScale.y;

    public Vector3 CenterOffset => -(0.5f * Mathf.Abs(transform.localScale.y) + Round) * transform.up;

    public override Aabb RawBoundsRs
    {
      get
      {
        Vector3 posRs = PointRs(transform.position) + VectorRs(PivotShiftOffset);
        Vector3 size = VectorUtil.Abs(transform.localScale);
        float maxRadius = m_radius;
        Vector3 r = new Vector3(maxRadius + Mathf.Max(0.0f, size.x - 1.0f), 0.5f * size.y, maxRadius + Mathf.Max(0.0f, size.z - 1.0f));
        Aabb bounds = new Aabb(-r, r);
        bounds.Rotate(RotationRs(transform.rotation));
        Vector3 round = m_round * Vector3.one;
        bounds.Min += posRs - round;
        bounds.Max += posRs + round;
        return bounds;
      }
    }

    public override void SanitizeParameters()
    {
      base.SanitizeParameters();

      Validate.NonNegative(ref m_radius);
      Validate.NonNegative(ref m_round);
    }

    public override int FillComputeData(NativeArray<SdfBrush> aBrush, int iStart, List<Transform> aBone)
    {
      SdfBrush brush = SdfBrush.New();
      brush.Type = (int) SdfBrush.TypeEnum.Cylinder;
      brush.Radius = m_radius;
      brush.Data0.x = m_round;
      brush.Data0.y = -m_radius;
      brush.Data0.z = PivotShift;

      if (aBone != null)
      {
        brush.BoneIndex = aBone.Count;
        aBone.Add(gameObject.transform);
      }

      aBrush[iStart] = brush;

      return 1;
    }

    public override void DrawSelectionGizmosRs()
    {
      base.DrawSelectionGizmosRs();

      float r = Mathf.Max(MathUtil.Epsilon, Radius);
      float h = Mathf.Max(0.01f * r, Mathf.Abs(transform.localScale.y));
      float a = Mathf.Atan(r / h);
      float sInv = Mathf.Min(25.0f * r, 1.0f / Mathf.Sin(a));
      float tInv = Mathf.Min(25.0f * r, 1.0f / Mathf.Tan(0.5f * (MathUtil.HalfPi - a)));
      float H = h + (1.0f + sInv) * Round;
      float R = r + tInv * Round;

      Vector3 xCornerOffsetRs = Mathf.Max(0.0f, transform.localScale.x - 1.0f) * VectorRs(transform.right);
      Vector3 zCornerOffsetRs = Mathf.Max(0.0f, transform.localScale.z - 1.0f) * VectorRs(transform.forward);

      GizmosUtil.DrawInvisibleCone(PointRs(transform.position) + VectorRs(CenterOffset + PivotShiftOffset) + xCornerOffsetRs + zCornerOffsetRs, R, H, RotationRs(transform.rotation));
      GizmosUtil.DrawInvisibleCone(PointRs(transform.position) + VectorRs(CenterOffset + PivotShiftOffset) + xCornerOffsetRs - zCornerOffsetRs, R, H, RotationRs(transform.rotation));
      GizmosUtil.DrawInvisibleCone(PointRs(transform.position) + VectorRs(CenterOffset + PivotShiftOffset) - xCornerOffsetRs + zCornerOffsetRs, R, H, RotationRs(transform.rotation));
      GizmosUtil.DrawInvisibleCone(PointRs(transform.position) + VectorRs(CenterOffset + PivotShiftOffset) - xCornerOffsetRs - zCornerOffsetRs, R, H, RotationRs(transform.rotation));

      GizmosUtil.DrawInvisibleCylinder(PointRs(transform.position) + VectorRs(PivotShiftOffset) + xCornerOffsetRs + zCornerOffsetRs, Round, h + 2.0f * Round, RotationRs(transform.rotation));
      GizmosUtil.DrawInvisibleCylinder(PointRs(transform.position) + VectorRs(PivotShiftOffset) + xCornerOffsetRs - zCornerOffsetRs, Round, h + 2.0f * Round, RotationRs(transform.rotation));
      GizmosUtil.DrawInvisibleCylinder(PointRs(transform.position) + VectorRs(PivotShiftOffset) - xCornerOffsetRs + zCornerOffsetRs, Round, h + 2.0f * Round, RotationRs(transform.rotation));
      GizmosUtil.DrawInvisibleCylinder(PointRs(transform.position) + VectorRs(PivotShiftOffset) - xCornerOffsetRs - zCornerOffsetRs, Round, h + 2.0f * Round, RotationRs(transform.rotation));

      Vector3 boxCoreSize = VectorUtil.CompMul(VectorUtil.Max(new Vector3(1.0f, 0.0f, 1.0f), transform.localScale), new Vector3(2.0f, 1.0f, 2.0f)) + new Vector3(-2.0f, 0.0f, -2.0f) + 2.0f * Round * Vector3.one;
      GizmosUtil.DrawInvisibleBox(PointRs(transform.position) + VectorRs(PivotShiftOffset), boxCoreSize, RotationRs(transform.rotation));
    }

    public override void DrawOutlineGizmosRs()
    {
      base.DrawOutlineGizmosRs();

      float r = Mathf.Max(MathUtil.Epsilon, Radius);
      float h = Mathf.Max(0.01f * r, Mathf.Abs(transform.localScale.y));
      float a = Mathf.Atan(r / h);
      float sInv = Mathf.Min(25.0f * r, 1.0f / Mathf.Sin(a));
      float tInv = Mathf.Min(25.0f * r, 1.0f / Mathf.Tan(0.5f * (MathUtil.HalfPi - a)));
      float H = h + (1.0f + sInv) * Round;
      float R = r + tInv * Round;
      GizmosUtil.DrawWireCone(PointRs(transform.position) + VectorRs(CenterOffset + PivotShiftOffset), R, H, RotationRs(transform.rotation));
    }
  }
}

