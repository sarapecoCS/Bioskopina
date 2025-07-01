using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class Rating
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public int MovieId { get; set; }

    public int? RatingValue { get; set; }

    public string ReviewText { get; set; } = null!;

    public DateTime DateAdded { get; set; }

    public virtual Bioskopina Movie{ get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
