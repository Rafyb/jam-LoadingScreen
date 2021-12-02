using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class CanvasVisualOption : MonoBehaviour
{
    public Color StartColor;
    public Color OnTriggerColor;
    public TMPro.TextMeshProUGUI TextButton;

    private Vector3 scaleChange;


    private void Awake()
    {
        TextButton.DOColor(StartColor, 0.2f);

        scaleChange = new Vector3(1f, 1f, 1f);
    }
    public void OntriggerEnter()
    {
        TextButton.DOColor(OnTriggerColor, 0.2f);
        this.gameObject.transform.localScale += scaleChange;
    }
    public void OnTriggerExit()
    {
        TextButton.DOColor(StartColor, 0.2f);
        this.gameObject.transform.localScale -= scaleChange;
    }
}
