using UnityEngine;
using System.Collections;

public class CameraImage : MonoBehaviour
{
    public enum EffectNode
    {
        DepthImage01
    }

    public Material baseMat;
    public EffectNode node = EffectNode.DepthImage01;
    void Awake()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }
    void Start()
    {
        switch(node)
        {
            case EffectNode.DepthImage01:
                break;
        }
    }
    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {

        Graphics.Blit(src, dst, baseMat);

    }
}
