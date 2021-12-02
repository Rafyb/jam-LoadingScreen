using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LoadingPage : MonoBehaviour
{
    private float _TimeToLoad = 10f;
    private float _TimerLoad = 0f;
    private bool _Reday = true;
    private int _Nb = 0;
    private float _TimerText = 0;

    public Fade Fade;
    public string NextScene;
    public GameObject PlayBtn;
    public Image LoadBar;
    public TMP_Text LoadingTxt;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(Play());
    }

    // Update is called once per frame
    void Update()
    {
        if (_Reday) return;
        
        // Loading bar
        _TimerLoad += Time.deltaTime;
        LoadBar.fillAmount = _TimerLoad / _TimeToLoad;

        if (_TimerLoad >= _TimeToLoad)
        {
            _Reday = true;
            PlayBtn.SetActive(true);
        }

        // Loading Text
        _TimerText -= Time.deltaTime;
        if (_TimerText <= 0f)
        {
            _TimerText += 0.7f;
            _Nb  = (_Nb+1)%4;
            string dots = "";
            for (int i = 0; i < _Nb; i++)
            {
                dots += ".";
            }

            LoadingTxt.text = "LOADING" + dots;
        }

    }

    public void StartGame()
    {
        Fade.StartFade();
        StartCoroutine(ChangeScene());
    }

    IEnumerator ChangeScene()
    {
        yield return new WaitForSeconds(Fade.Delay+0.2f);
        SceneManager.LoadScene(NextScene);
    }
    
    IEnumerator Play()
    {
        yield return new WaitForSeconds(Fade.Delay+0.2f);
        _Reday = false;
    }
}
