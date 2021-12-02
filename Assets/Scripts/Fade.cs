using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

public class Fade : MonoBehaviour
{
    public Image BlackScreen;
    public float Delay;

    private void Start()
    {
        EndFade();
    }

    public void StartFade()
    {
        BlackScreen.DOKill();
        BlackScreen.DOFade(1f,Delay);
    }

    public void EndFade()
    {
        BlackScreen.DOKill();
        BlackScreen.DOFade(0f,Delay);
    }
}
