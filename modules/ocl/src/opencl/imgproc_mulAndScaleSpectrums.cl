/*M///////////////////////////////////////////////////////////////////////////////////////
//
//  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.
//
//  By downloading, copying, installing or using the software you agree to this license.
//  If you do not agree to this license, do not download, install,
//  copy or use the software.
//
//
//                           License Agreement
//                For Open Source Computer Vision Library
//
// Copyright (C) 2010-2012, Multicoreware, Inc., all rights reserved.
// Copyright (C) 2010-2012, Advanced Micro Devices, Inc., all rights reserved.
// Third party copyrights are property of their respective owners.
//
// @Authors
//    Peng Xiao, pengxiao@multicorewareinc.com
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//   * Redistribution's of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//
//   * Redistribution's in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other oclMaterials provided with the distribution.
//
//   * The name of the copyright holders may not be used to endorse or promote products
//     derived from this software without specific prior written permission.
//
// This software is provided by the copyright holders and contributors as is and
// any express or implied warranties, including, but not limited to, the implied
// warranties of merchantability and fitness for a particular purpose are disclaimed.
// In no event shall the uintel Corporation or contributors be liable for any direct,
// indirect, incidental, special, exemplary, or consequential damages
// (including, but not limited to, procurement of substitute goods or services;
// loss of use, data, or profits; or business uinterruption) however caused
// and on any theory of liability, whether in contract, strict liability,
// or tort (including negligence or otherwise) arising in any way out of
// the use of this software, even if advised of the possibility of such damage.
//
//M*/

typedef float2 cfloat;
inline cfloat cmulf(cfloat a, cfloat b)
{
    return (cfloat)( a.x*b.x - a.y*b.y, a.x*b.y + a.y*b.x);
}

inline cfloat conjf(cfloat a)
{
    return (cfloat)( a.x, - a.y );
}

__kernel void
mulAndScaleSpectrumsKernel(
    __global const cfloat* a,
    __global const cfloat* b,
    float scale,
    __global cfloat* dst,
    uint cols,
    uint rows,
    uint mstep
)
{
    const uint x = get_global_id(0);
    const uint y = get_global_id(1);
    const uint idx = mad24(y, mstep / sizeof(cfloat), x);
    if (x < cols && y < rows)
    {
        cfloat v = cmulf(a[idx], b[idx]);
        dst[idx] = (cfloat)( v.x * scale, v.y * scale );
    }
}
__kernel void
mulAndScaleSpectrumsKernel_CONJ(
    __global const cfloat* a,
    __global const cfloat* b,
    float scale,
    __global cfloat* dst,
    uint cols,
    uint rows,
    uint mstep
)
{
    const uint x = get_global_id(0);
    const uint y = get_global_id(1);
    const uint idx = mad24(y, mstep / sizeof(cfloat), x);
    if (x < cols && y < rows)
    {
        cfloat v = cmulf(a[idx], conjf(b[idx]));
        dst[idx] = (cfloat)( v.x * scale, v.y * scale );
    }
}
