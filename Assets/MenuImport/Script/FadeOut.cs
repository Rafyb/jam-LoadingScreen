using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class FadeOut : MonoBehaviour
{

    public Image Fade1;

    public TMPro.TextMeshProUGUI Text;
    public Color ColorInitial;
    public Color ColorEnd;
    public float TimeFade;

    public GameObject MainMenu;

    public float WaitTime;
    private float AllTime;
    public float endTime;

    // Start is called before the first frame update
    void Start()
    {
        Text.color = ColorInitial;
        
    }

    private void Update()
    {
        
        if (AllTime > WaitTime)
        {
            FadeOuut();
            Text.DOKill();
            Text.DOColor(ColorEnd, TimeFade);
        }


        if (AllTime > endTime)
        {
            Debug.Log("hey");

            MainMenu.gameObject.SetActive(true);
            
            this.gameObject.SetActive(false);
        }
        else
        {
            AllTime += Time.deltaTime;
        }
    }

    // Update is called once per frame
    void FadeIn()

    {
        Fade1.CrossFadeAlpha(1, 3, false);
    }

    void FadeOuut()
    {
        Fade1.CrossFadeAlpha(0, TimeFade, false);
    }
}
