using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class Post
{
    public int Id { get; set; }


    public int UserId { get; set; }

    public string Content { get; set; } = null!;

    public int LikesCount { get; set; }

    public int DislikesCount { get; set; }

    public DateTime DatePosted { get; set; }

    public string? VideoUrl { get; set; }


    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual User User { get; set; } = null!;

    public virtual ICollection<UserPostAction> UserPostActions { get; set; } = new List<UserPostAction>();
  
}
