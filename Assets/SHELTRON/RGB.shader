//
// KinoGlitch - Video glitch effect
//
// Copyright (C) 2015 Keijiro Takahashi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
Shader "Hidden/SHELTRON/RGB"
{
    Properties
    {
        _MainTex  ("-", 2D) = "" {}
        _NoiseTex ("-", 2D) = "" {}
        _TrashTex ("-", 2D) = "" {}
    }

    CGINCLUDE

    #include "UnityCG.cginc"

    sampler2D _MainTex;
    sampler2D _NoiseTex;
    sampler2D _TrashTex;
    float _Intensity;

    float4 frag(v2f_img i) : SV_Target 
    {
		float d = 0.04 * sin(40.0 * i.uv - float2(0.5, 0.5));

        float4 c0 = tex2D(_MainTex, i.uv - 2.0 * d * _Intensity);
        float4 c1 = tex2D(_MainTex, i.uv -  d * _Intensity);
        float4 c2 = tex2D(_MainTex, i.uv);
        float4 c3 = tex2D(_MainTex, i.uv + d * _Intensity);
        float4 c4 = tex2D(_MainTex, i.uv + 2.0 * d * _Intensity);

		float denom = lerp(3.0, 1.0, _Intensity);

        return float4(
			(c0.r +  + c1.r +  + c2.r) / denom,
			(c1.g +  + c2.g +  + c3.g) / denom,
			(c2.b +  + c3.b +  + c4.b) / denom,
			1.0);
    }

    ENDCG

    SubShader
    {
        Pass
        {
            ZTest Always Cull Off ZWrite Off
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma target 3.0
            ENDCG
        }
    }
}
