using System;
using System.Collections.Generic;

namespace Bioskopina.Services.Database;

public partial class QAcategory
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public virtual ICollection<QA> QAs { get; set; } = new List<QA>();
}
