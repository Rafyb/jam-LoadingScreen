using System;
using System.Collections;
using System.Collections.Generic;
using TreeEditor;
using UnityEngine;

public class Projectile : MonoBehaviour
{
    public float Speed;
    
    void Update()
    {
        Vector3 pos = transform.position;
        pos.x -= Speed * Time.deltaTime;
        transform.position = pos;
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.tag.Equals("Player"))
        {
            Game.Instance.Death();
            Game.Instance.DestroyProj(this);
        }
        if (other.tag.Equals("Finish"))
        {
            Game.Instance.DestroyProj(this);
        }
    }
}
