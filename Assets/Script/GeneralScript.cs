using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GeneralScript : MonoBehaviour
{
    [Header("Cam Var")]
    public GameObject _camera;
    public GameObject cameraToGo;
    Vector3 vector1;
    Quaternion quater;
    [HideInInspector]
    public bool go = false;
    [Header("Tweak")]
    public float threshold;
    public float timeGo;
    public float timeRotate;

    public CameraShake cameraShake;
    public float shakeDuration;
    public float shakeMagnitude;

    private void Start()
    {

    }
    private void Update()
    {
        if (go)
        {
            vector1 = new Vector3(Mathf.Lerp(_camera.transform.position.x, cameraToGo.transform.position.x, timeGo),
                Mathf.Lerp(_camera.transform.position.y, cameraToGo.transform.position.y, timeGo),
                Mathf.Lerp(_camera.transform.position.z, cameraToGo.transform.position.z, timeGo));

            quater = new Quaternion(Mathf.Lerp(_camera.transform.rotation.x, 0, timeRotate),
                Mathf.Lerp(_camera.transform.rotation.y, 90, timeRotate),
                Mathf.Lerp(_camera.transform.rotation.z, 0, timeRotate), 1);

            _camera.transform.position = vector1;
            _camera.transform.rotation = quater;

        }

        if (_camera.transform.position.x >= cameraToGo.transform.position.x - threshold)
        {
            SceneManager.LoadScene(0);

        }
    }
    public void shake()
    {
        StartCoroutine(cameraShake.Shake(shakeDuration, shakeMagnitude));
    }
}
