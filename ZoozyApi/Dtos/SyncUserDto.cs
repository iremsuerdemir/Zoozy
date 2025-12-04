namespace ZoozyApi.Models.Dto
{
    public class SyncUserDto
    {
        public string? FirebaseUid { get; set; }
        public string? Email { get; set; }
        public string? DisplayName { get; set; }
        public string? PhotoUrl { get; set; }
        public string? Provider { get; set; }
    }
}
