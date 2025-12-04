namespace ZoozyApi.Models
{
    public class User
    {
        public int Id { get; set; }
        public string? FirebaseUid { get; set; }
        public string Email { get; set; } = string.Empty;
        public string? PasswordHash { get; set; }
        public string DisplayName { get; set; } = string.Empty;
        public string? PhotoUrl { get; set; }
        public string Provider { get; set; } = "local";
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }
        public bool IsActive { get; set; } = true;
    }
}
