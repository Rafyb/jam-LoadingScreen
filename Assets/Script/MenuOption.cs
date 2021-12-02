using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.Audio;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.UI;

public class MenuOption : MonoBehaviour
{
    public GameObject canvasOption;
    public GameObject positionIn;
    public GameObject positionOut;
    public float timeGo;
    Vector3 vector;
    public bool inOut = false;

    int switchState;
    public GameObject switchOn;

    public AudioMixer mixerMusic;
    public AudioMixer mixerSoundEffect;

    public PostProcessVolume postProcess;
    public Slider sliderWeightPP;

    private void Start()
    {
        
    }

    public void OnSwitchButtonClicked()
    {
        switchOn.transform.DOLocalMoveX(-switchOn.transform.localPosition.x, 0.2f);
    }

    private void Update()
    {
        if (inOut)
        {
            vector = new Vector3(Mathf.Lerp(canvasOption.transform.position.x, positionIn.transform.position.x, timeGo),
                 Mathf.Lerp(canvasOption.transform.position.y, positionIn.transform.position.y, timeGo),
                 Mathf.Lerp(canvasOption.transform.position.z, positionIn.transform.position.z, timeGo));

            canvasOption.transform.position = vector;
        }
        else
        {
            vector = new Vector3(Mathf.Lerp(canvasOption.transform.position.x, positionOut.transform.position.x, timeGo),
                Mathf.Lerp(canvasOption.transform.position.y, positionOut.transform.position.y, timeGo),
                Mathf.Lerp(canvasOption.transform.position.z, positionOut.transform.position.z, timeGo));

            canvasOption.transform.position = vector;
        }
    }
    
    public void In()
    {
        inOut = true;
    }
    public void Out()
    {
        inOut = false;
    }

    public void SetLevelMusic (float sliderValueMusic)
    {
        mixerMusic.SetFloat("MusicVolume", Mathf.Log10 (sliderValueMusic) * 20);
    }
    public void SetLevelSoundEffect(float sliderValueSoundEffectMusic)
    {
        mixerSoundEffect.SetFloat("SoundEffectVolume", Mathf.Log10(sliderValueSoundEffectMusic) * 20);
    }

    public void SetLevelVisualEffect()
    {
        postProcess.weight = sliderWeightPP.value;
     
    }
}
