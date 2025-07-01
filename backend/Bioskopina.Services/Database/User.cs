using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class User
{
    public int Id { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string PasswordSalt { get; set; } = null!;

    public string? Email { get; set; }

    public int ProfilePictureId { get; set; }

    public DateTime DateJoined { get; set; }

    public string Username { get; set; } = null!;

   

    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual ICollection<Donation> Donations { get; set; } = new List<Donation>();

    public virtual ICollection<List> Lists { get; set; } = new List<List>();

    public virtual ICollection<Post> Posts { get; set; } = new List<Post>();

    public virtual ICollection<PreferredGenre> PreferredGenres { get; set; } = new List<PreferredGenre>();

    public virtual UserProfilePicture ProfilePicture { get; set; } = null!;

    public virtual ICollection<QA> QAs { get; set; } = new List<QA>();

    public virtual ICollection<Rating> Ratings { get; set; } = new List<Rating>();

    public virtual ICollection<UserCommentAction> UserCommentActions { get; set; } = new List<UserCommentAction>();

    public virtual ICollection<UserPostAction> UserPostActions { get; set; } = new List<UserPostAction>();

    public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();

    public virtual ICollection<Watchlist> Watchlists { get; set; } = new List<Watchlist>();
}
