namespace ZoozyApi.Dtos
{
    public class UserDto
    {
        public int Id { get; set; }
        public string Email { get; set; } = string.Empty;
        public string? DisplayName { get; set; }
        public string? PhotoUrl { get; set; }
        public string Provider { get; set; } = "local"; // 'local' or 'google'
        public string? FirebaseUid { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
