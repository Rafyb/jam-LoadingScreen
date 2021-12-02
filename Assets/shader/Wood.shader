// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Wood"
{
	Properties
	{
		_ASEOutlineColor( "Outline Color", Color ) = (0,0,0,0)
		_ASEOutlineWidth( "Outline Width", Float ) = 1
		_WOOD_ambient_occlusion("WOOD_ambient_occlusion", 2D) = "white" {}
		_AlbedoMap("Albedo Map", 2D) = "white" {}
		[NoScaleOffset]_MRAMap("MRA Map", 2D) = "white" {}
		[NoScaleOffset][Normal]_NormalMap("Normal Map", 2D) = "bump" {}
		_Color("Color", Color) = (1,1,1,1)
		_AOColor("AO Color", Color) = (1,1,1,1)
		_BumpScale1("Normal Intensity", Range( 0 , 2)) = 1
		_Tesselation("Tesselation", Range( 0 , 50)) = 0
		_WOOD_roughness("WOOD_roughness", 2D) = "white" {}
		_WOOD_height("WOOD_height", 2D) = "white" {}
		_Displacement("Displacement", Range( 0 , 20)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc tessellate:tessFunction 
		
		
		
		
		struct Input {
			half filler;
		};
		float4 _ASEOutlineColor;
		float _ASEOutlineWidth;
		
		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_0 = (_Tesselation).xxxx;
			return temp_cast_0;
		}

		void outlineVertexDataFunc( inout appdata_full v )
		{
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _ASEOutlineColor.rgb;
			o.Alpha = 1;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Displacement;
		uniform sampler2D _WOOD_height;
		SamplerState sampler_WOOD_height;
		uniform float4 _WOOD_height_ST;
		uniform sampler2D _NormalMap;
		uniform float _BumpScale1;
		uniform float4 _AOColor;
		uniform float4 _Color;
		uniform sampler2D _AlbedoMap;
		uniform sampler2D _MRAMap;
		uniform sampler2D _WOOD_roughness;
		uniform float4 _WOOD_roughness_ST;
		uniform sampler2D _WOOD_ambient_occlusion;
		uniform float4 _WOOD_ambient_occlusion_ST;
		uniform float _Tesselation;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_0 = (_Tesselation).xxxx;
			return temp_cast_0;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_WOOD_height = v.texcoord * _WOOD_height_ST.xy + _WOOD_height_ST.zw;
			v.vertex.xyz += ( ( ase_vertexNormal * _Displacement ) * tex2Dlod( _WOOD_height, float4( uv_WOOD_height, 0, 0.0) ).r );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = UnpackScaleNormal( tex2D( _NormalMap, i.uv_texcoord ), _BumpScale1 );
			float4 blendOpSrc31 = _AOColor;
			float4 blendOpDest31 = ( _Color * tex2D( _AlbedoMap, i.uv_texcoord ) );
			float4 tex2DNode19 = tex2D( _MRAMap, i.uv_texcoord );
			float4 lerpBlendMode31 = lerp(blendOpDest31,( blendOpSrc31 * blendOpDest31 ),( 1.0 - tex2DNode19.b ));
			o.Albedo = ( saturate( lerpBlendMode31 )).rgb;
			float2 uv_WOOD_roughness = i.uv_texcoord * _WOOD_roughness_ST.xy + _WOOD_roughness_ST.zw;
			o.Smoothness = ( 1.0 - tex2D( _WOOD_roughness, uv_WOOD_roughness ) ).r;
			float2 uv_WOOD_ambient_occlusion = i.uv_texcoord * _WOOD_ambient_occlusion_ST.xy + _WOOD_ambient_occlusion_ST.zw;
			o.Occlusion = tex2D( _WOOD_ambient_occlusion, uv_WOOD_ambient_occlusion ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
825;73;607;597;608.1863;-331.2515;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;15;-2440.998,543.3751;Inherit;False;485.5201;232.0919;Viens teinter l'albedo si on met une couleur;2;27;22;Albedo Tint;0.3679245,0.3679245,0.3679245,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;17;-2995.548,513.9507;Float;True;Property;_MRAMap;MRA Map;2;1;[NoScaleOffset];Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;18;-3010.022,285.5493;Float;True;Property;_AlbedoMap;Albedo Map;1;0;Create;True;0;0;False;0;False;b0ba6e16e82fdb14f9edd57041f551f7;b0ba6e16e82fdb14f9edd57041f551f7;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-3012.271,1079.174;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;21;-2994.172,765.323;Float;True;Property;_NormalMap;Normal Map;3;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;False;605fc95f6b65cd1478f5346b5ff93b5d;baf271593df05c44d823664d1a03a4a1;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;24;-2458.086,828.2856;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;23;-1889.045,385.6049;Inherit;False;544.5194;422.8966;Viens teinter l'AO si on met une couleur dedans;3;31;29;28;AO Tint;0.254717,0.254717,0.254717,1;0;0
Node;AmplifyShaderEditor.ColorNode;22;-2390.998,593.3749;Float;False;Property;_Color;Color;4;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-2455.386,1048.475;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-687.1815,726.698;Inherit;False;Property;_Displacement;Displacement;12;0;Create;True;0;0;False;0;False;0;0.89;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;40;-553.6785,486.6476;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;45;-943.6802,315.4781;Inherit;True;Property;_WOOD_roughness;WOOD_roughness;10;0;Create;True;0;0;False;0;False;-1;d3bc429c80f1c154c844dd7dd4e882d2;d3bc429c80f1c154c844dd7dd4e882d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-2460.789,1255.156;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-2336.627,1578.026;Float;False;Property;_BumpScale1;Normal Intensity;7;0;Create;False;0;0;False;0;False;1;0.446;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;-1839.045,435.6049;Float;False;Property;_AOColor;AO Color;5;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;39;-311.9279,687.1378;Inherit;True;Property;_WOOD_height;WOOD_height;11;0;Create;True;0;0;False;0;False;-1;9e5cfce8ce175224b93ef3c57cb12142;9e5cfce8ce175224b93ef3c57cb12142;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;13;-1760.948,-716.9335;Inherit;False;1049.008;434.4694;;6;7;8;9;10;11;12;World UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2113.047,598.03;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;29;-1805.921,719.6556;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-237.2531,561.9487;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;32;-1450.433,1068.62;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;31;-1562.31,565.2019;Inherit;False;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-306.8865,430.4823;Inherit;False;Property;_Tesselation;Tesselation;9;0;Create;True;0;0;False;0;False;0;50;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1376.205,-429.3767;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;7;-1710.948,-666.9335;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1637.262,1066.992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;33;-1906.475,1411.684;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;20;-1919.651,1010.916;Float;False;Property;_Rough1;Roughness;6;0;Create;False;0;0;False;0;False;1;2;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-627.2374,135.1617;Inherit;True;Property;_WOOD_ambient_occlusion;WOOD_ambient_occlusion;0;0;Create;True;0;0;False;0;False;-1;c802ee10ee17aad498bf307fe0a0f24a;c802ee10ee17aad498bf307fe0a0f24a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-6.178589,595.1477;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;46;-546.7731,326.813;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1174.117,-465.4641;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1388.836,-591.7692;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1625.776,-420.0797;Inherit;False;Property;_Tilling;Tilling;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-935.9398,-503.3552;Inherit;False;WorldUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Custom/Wood;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;True;1;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;18;0
WireConnection;24;1;16;0
WireConnection;19;0;17;0
WireConnection;19;1;16;0
WireConnection;25;0;21;0
WireConnection;25;1;16;0
WireConnection;27;0;22;0
WireConnection;27;1;24;0
WireConnection;29;0;19;3
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;32;0;30;0
WireConnection;31;0;28;0
WireConnection;31;1;27;0
WireConnection;31;2;29;0
WireConnection;10;0;7;3
WireConnection;10;1;8;0
WireConnection;30;0;20;0
WireConnection;30;1;19;2
WireConnection;33;0;25;0
WireConnection;33;1;26;0
WireConnection;43;0;42;0
WireConnection;43;1;39;1
WireConnection;46;0;45;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;9;0;7;1
WireConnection;9;1;8;0
WireConnection;12;0;11;0
WireConnection;0;0;31;0
WireConnection;0;1;33;0
WireConnection;0;4;46;0
WireConnection;0;5;1;0
WireConnection;0;11;43;0
WireConnection;0;14;44;0
ASEEND*/
//CHKSM=C4889417CF7DC542B09099DB9858BCEA10D079C5