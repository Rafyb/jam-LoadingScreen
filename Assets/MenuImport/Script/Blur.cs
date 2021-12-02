using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class Blur : MonoBehaviour
{
    private DepthOfField depth;
    //public float StartDepth;
    public float endDepth;
    public float transitionSpeed;
    public float WaitTime;
    private float AllTime;

    // public float FocalLength;
    // Start is called before the first frame update
    void Start()
    {
        PostProcessVolume volume = gameObject.GetComponent<PostProcessVolume>();
        volume.profile.TryGetSettings(out depth);
        //Depth.focalLength.value = StartDepth;
    }

    // Update is called once per frame
    void Update()
    {
        
        if (AllTime > WaitTime) 
        { 
        depth.focalLength.value = Mathf.Lerp(depth.focalLength.value, endDepth, Time.deltaTime * transitionSpeed);
        }
        else
        {
            AllTime += Time.deltaTime;
        }
    }
}
