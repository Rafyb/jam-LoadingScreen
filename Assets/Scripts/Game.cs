using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DG.Tweening;
using TMPro;
using UnityEditor;
using UnityEngine;
using Random = UnityEngine.Random;

public class Game : MonoBehaviour
{
    public static Game Instance;
    public TMP_Text ScoreTxt;
    public Transform[] Lines;
    public Transform StartProj;
    public GameObject Player;
    public GameObject ProjectilePrefab;
    public float Speed;
    
    private bool _Moving;
    private int _LineIdx;
    private int _Score;
    private float _ScoreTimer;
    private float _TimerProjectile;
    private bool _End = false;
    
    private float _TimeProjectile = 2f;
    private int _MaxProjectile = 2;
    private float _SpeedProjectile = 1;

    private List<Projectile> _projectiles = new List<Projectile>();

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
        if (_End) return;
        
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
            _Score++;
            ScoreTxt.text = _Score.ToString();

            if (_Score % 20 == 0)
            {
                _SpeedProjectile += 0.5f;
                foreach (Projectile proj in _projectiles)
                {
                    proj.Speed = _SpeedProjectile;
                }
            }
            if (_Score % 40 == 0 && _MaxProjectile <= 5)
            {
                _MaxProjectile += 1;
            }
        }

        _TimerProjectile += Time.deltaTime;
        if (_TimerProjectile > _TimeProjectile)
        {
            _TimerProjectile -= _TimeProjectile;
            Shoot();
        }
    }

    private void Shoot()
    {
        int nb = Random.Range(1, _MaxProjectile);

        int[] lines = new int[nb];
        for (int i = 0; i < nb; i++) lines[i] = -1;

        for (int i = 0; i < nb; i++)
        {
            int idx = Random.Range(0, Lines.Length);
            if (lines.Contains(idx)) idx = (idx + 1) % Lines.Length;
            lines[i] = idx;
        }

        for (int i = 0; i < nb; i++)
        {
            GameObject proj = Instantiate(ProjectilePrefab,new Vector3(StartProj.position.x, Lines[lines[i]].position.y, 0f), Quaternion.identity);
            proj.GetComponent<Projectile>().Speed = _SpeedProjectile;
            _projectiles.Add(proj.GetComponent<Projectile>());
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

    public void Death()
    {
        Player.GetComponent<SpriteAnimation>().Kill();
        _End = true;
    }

    public void DestroyProj(Projectile projectile)
    {
        int idx = _projectiles.IndexOf(projectile);
        Destroy(_projectiles[idx].gameObject);
        _projectiles.RemoveAt(idx);
    }
}
