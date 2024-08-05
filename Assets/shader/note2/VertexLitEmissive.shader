Shader "Note2/VertexLitEmissive"
{
    Properties
    {
        _Color ("Glow Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float4 color : COLOR;
            };

            float4 _Color;

            v2f vert (appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.color * _Color; // 逐顶点的自发光
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.color; // 使用逐顶点颜色作为最终的颜色
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
