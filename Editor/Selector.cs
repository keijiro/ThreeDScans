using UnityEditor;

namespace JP.Keijiro.ThreeDScans
{
    static class Selector
    {
        [MenuItem("Packages/Three D Scans")]
        static void OpenPackageDirectory()
        {
            var path = "Packages/jp.keijiro.three-d-scans/README.md";
            Selection.activeObject = AssetDatabase.LoadMainAssetAtPath(path);
            EditorGUIUtility.PingObject(Selection.activeObject);
        }
    }
}
