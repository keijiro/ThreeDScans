Shader "ThreeDScans"
{
    Properties
    {
        _NormalMap("Normal Map", 2D) = "bump" {}
        _OcclusionMap("Occlusion Map", 2D) = "white" {}
        _CurvatureMap("Curvature Map", 2D) = "white" {}

        [Header(Channel 1)]

        _Color1("Color", Color) = (1, 1, 1, 1)
        _Smoothness1("Smoothness", Range(0, 1)) = 0
        [Gamma] _Metallic1("Metallic", Range(0, 1)) = 0

        [Header(Channel 2)]

        _Color2("Color", Color) = (1, 1, 1, 1)
        _Smoothness2("Smoothness", Range(0, 1)) = 0
        [Gamma] _Metallic2("Metallic", Range(0, 1)) = 0

        [Header(Detail Maps)]
        _DetailAlbedoMap("Albedo", 2D) = "gray" {}
        _DetailNormalMap("Normal Map", 2D) = "bump" {}
        _DetailNormalMapScale("Scale", Range(0, 2)) = 1
        _DetailMapScale("Mapping Scale", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface Surface Standard vertex:Vertex addshadow fullforwardshadows
        #pragma target 3.5

        struct Input
        {
            float2 baseCoord;
            float3 localCoord;
            float3 localNormal;
        };

        sampler2D _NormalMap;
        sampler2D _OcclusionMap;
        sampler2D _CurvatureMap;

        half3 _Color1;
        half _Smoothness1;
        half _Metallic1;

        half3 _Color2;
        half _Smoothness2;
        half _Metallic2;

        sampler2D _DetailAlbedoMap;
        sampler2D _DetailNormalMap;
        half _DetailNormalMapScale;
        half _DetailMapScale;

        void Vertex(inout appdata_full v, out Input data)
        {
            UNITY_INITIALIZE_OUTPUT(Input, data);
            data.baseCoord = v.texcoord.xy;
            data.localCoord = v.vertex.xyz;
            data.localNormal = v.normal.xyz;
        }

        void Surface(Input IN, inout SurfaceOutputStandard o)
        {
            // Curvature map
            half cv = tex2D(_CurvatureMap, IN.baseCoord).g;
            cv = pow(cv, 12);

            // Triplanar mapping
            float3 tc = IN.localCoord * _DetailMapScale;

            // Blend factor of triplanar mapping
            float3 bf = abs(IN.localNormal);
            bf /= dot(bf, 1);

            // Base color
            half3 am = tex2D(_DetailAlbedoMap, tc.yz).rgb * bf.x +
                       tex2D(_DetailAlbedoMap, tc.zx).rgb * bf.y +
                       tex2D(_DetailAlbedoMap, tc.xy).rgb * bf.z;
            o.Albedo = lerp(_Color1, _Color2, cv) * am;

            // Normal map
            half3 nb = UnpackNormal(tex2D(_NormalMap, IN.baseCoord));
            half4 ns = tex2D(_DetailNormalMap, tc.yz) * bf.x +
                       tex2D(_DetailNormalMap, tc.zx) * bf.y +
                       tex2D(_DetailNormalMap, tc.xy) * bf.z;
            half3 nm = UnpackScaleNormal(ns, _DetailNormalMapScale);
            o.Normal = BlendNormals(nb, nm);

            // Occlusion map
            o.Occlusion = tex2D(_OcclusionMap, IN.baseCoord).g;

            // Etc.
            o.Metallic = lerp(_Metallic1, _Metallic2, cv);
            o.Smoothness = lerp(_Smoothness1, _Smoothness2, cv);
        }

        ENDCG
    }

    FallBack "Diffuse"
    CustomEditor "ThreeDScansInspector"
}
