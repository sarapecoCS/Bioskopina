using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class Comment
{
    public int Id { get; set; }

    public int PostId { get; set; }

    public User User { get; set; }
    
    public int UserId { get; set; }

    public string Content { get; set; } = null!;

    public int LikesCount { get; set; }

    public int DislikesCount { get; set; }

    public DateTime DateCommented { get; set; }

    public virtual Post Post { get; set; } = null!;


    public virtual ICollection<UserCommentAction> UserCommentActions { get; set; } = new List<UserCommentAction>();

}

