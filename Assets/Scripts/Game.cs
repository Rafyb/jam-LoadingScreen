using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using TMPro;
using UnityEngine;

public class Game : MonoBehaviour
{
    public static Game Instance;
    public TMP_Text ScoreTxt;
    public Transform[] Lines;
    public GameObject Player;
    public float Speed;
    
    private bool _Moving;
    private int _LineIdx;
    private int _Score;
    private float _ScoreTimer;

    private void Awake()
    {
        Instance = this;
    }

    void Start()
    {
        _LineIdx = Lines.Length/2;
        Player.transform.position = Lines[_LineIdx].position;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.DownArrow) && !_Moving)
        {
            TryDown();
        }
        
        if (Input.GetKeyDown(KeyCode.UpArrow) && !_Moving)
        {
            TryUp();
        }

        _ScoreTimer += Time.deltaTime;
        if (_ScoreTimer >= 1f)
        {
            _ScoreTimer -= 1f;
        }
    }

    private void TryUp()
    {
        if (_LineIdx == 0) return;

        _LineIdx--;
        _Moving = true;
        Player.transform.DOMove(Lines[_LineIdx].position,Speed).OnComplete(()=>
        {
            _Moving = false;
        });
    }

    private void TryDown()
    {
        if (_LineIdx == Lines.Length-1) return;
        
        _LineIdx++;
        _Moving = true;
        Player.transform.DOMove(Lines[_LineIdx].position,Speed).OnComplete(()=>
        {
            _Moving = false;
        });;
    }
}
