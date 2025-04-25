using UnityEngine;

public abstract class CharacterControllerBase : MonoBehaviour
{
    // Componentes comunes
    protected Rigidbody2D rb;
    protected Animator animator;
    protected SpriteRenderer spriteRenderer;

    // Movimiento
    [Header("Movimiento")]
    public float moveSpeed = 10f;
    protected bool facingRight;

    // Suelo
    [Header("Detección de suelo")]
    public Transform groundCheck;
    public LayerMask groundLayer;
    public float boxCastDistance = 0.1f;
    public Vector2 boxCastSize = new Vector2(0.5f, 0.1f);
    protected bool isGrounded;

    // Entrada
    protected float horizontalInput;

    // Dirección del personaje
    public Vector2 LastDirection { get; private set; }

    // Unity
    protected virtual void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
        spriteRenderer = GetComponent<SpriteRenderer>();
    }

    protected virtual void Update()
    {
        GetInput();
        HandleDirection();
        LastDirection = rb.velocity.normalized; // Se actualiza aquí
    }

    protected virtual void FixedUpdate()
    {
        CheckGround();
        Move();
    }

    protected virtual void GetInput()
    {
        horizontalInput = Input.GetAxisRaw("Horizontal");
    }

    protected virtual void Move()
    {
        rb.velocity = new Vector2(horizontalInput * moveSpeed, rb.velocity.y);
    }

    protected virtual void HandleDirection()
    {
        if (horizontalInput < 0 && facingRight)
            Flip();
        else if (horizontalInput > 0 && !facingRight)
            Flip();
    }

    protected abstract void Flip();

    protected virtual void CheckGround()
    {
        if (groundCheck != null)
        {
            RaycastHit2D hit = Physics2D.BoxCast(
                groundCheck.position,
                boxCastSize,
                0f,
                Vector2.down,
                boxCastDistance,
                groundLayer
            );

            isGrounded = hit.collider != null;
        }
    }

    private void OnDrawGizmosSelected()
    {
        if (groundCheck != null)
        {
            Gizmos.color = Color.green;
            Vector3 castPosition = groundCheck.position + Vector3.down * boxCastDistance * 0.5f;
            Gizmos.DrawWireCube(castPosition, boxCastSize);
        }
    }

    protected abstract void HandleFall();

}
