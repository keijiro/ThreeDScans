using UnityEngine;
using UnityEditor;

public class ThreeDScansInspector : ShaderGUI
{
    static class Labels
    {
        public static GUIContent albedoMap = new GUIContent("Albedo Map");
        public static GUIContent normalMap = new GUIContent("Normal Map");
        public static GUIContent occlusionMap = new GUIContent("Occlusion Map");
        public static GUIContent curvatureMap = new GUIContent("Curvature Map");
    }

    public override void OnGUI(MaterialEditor editor, MaterialProperty[] props)
    {
        EditorGUI.BeginChangeCheck();

        // Base maps
        EditorGUILayout.LabelField("Base Maps", EditorStyles.boldLabel);

        editor.TexturePropertySingleLine(
            Labels.normalMap, FindProperty("_NormalMap", props)
        );

        editor.TexturePropertySingleLine(
            Labels.occlusionMap, FindProperty("_OcclusionMap", props)
        );

        editor.TexturePropertySingleLine(
            Labels.curvatureMap, FindProperty("_CurvatureMap", props)
        );

        EditorGUILayout.Space();

        // Channel 1
        EditorGUILayout.LabelField("Channel 1", EditorStyles.boldLabel);
        editor.ColorProperty(FindProperty("_Color1", props), "Color");
        editor.RangeProperty(FindProperty("_Metallic1", props), "Metallic");
        editor.RangeProperty(FindProperty("_Smoothness1", props), "Smoothness");

        EditorGUILayout.Space();

        // Channel 2
        EditorGUILayout.LabelField("Channel 2", EditorStyles.boldLabel);
        editor.ColorProperty(FindProperty("_Color2", props), "Color");
        editor.RangeProperty(FindProperty("_Metallic2", props), "Metallic");
        editor.RangeProperty(FindProperty("_Smoothness2", props), "Smoothness");

        EditorGUILayout.Space();

        // Detail maps
        EditorGUILayout.LabelField("Detail Maps", EditorStyles.boldLabel);

        editor.TexturePropertySingleLine(
            Labels.albedoMap, FindProperty("_DetailAlbedoMap", props)
        );

        editor.TexturePropertySingleLine(
            Labels.normalMap,
            FindProperty("_DetailNormalMap", props),
            FindProperty("_DetailNormalMapScale", props)
        );

        editor.FloatProperty(FindProperty("_DetailMapScale", props), "Scale");
    }
}
