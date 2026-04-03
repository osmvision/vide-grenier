<?php
$host     = getenv('DB_HOST')     ?: 'db';
$dbname   = getenv('DB_NAME')     ?: 'vide_grenier';
$user     = getenv('DB_USER')     ?: 'app_user';
$password = getenv('DB_PASSWORD') ?: 'secret';

try {
    $pdo = new PDO(
        "mysql:host=$host;dbname=$dbname;charset=utf8",
        $user,
        $password,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
} catch (PDOException $e) {
    die('<p style="color:red;">Connexion échouée : ' . htmlspecialchars($e->getMessage()) . '</p>');
}

$stmt = $pdo->query('SELECT * FROM articles ORDER BY created_at DESC');
$articles = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Vide Grenier - Articles</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 900px; margin: 2rem auto; padding: 0 1rem; }
        h1   { color: #e67e22; }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { padding: .75rem 1rem; border: 1px solid #ddd; text-align: left; }
        th   { background: #f4f4f4; }
        tr:hover { background: #fafafa; }
        .badge { background: #e67e22; color: #fff; padding: .2rem .6rem; border-radius: 12px; font-size: .85rem; }
    </style>
</head>
<body>
    <h1>Vide Grenier - Liste des articles</h1>

    <?php if (empty($articles)): ?>
        <p>Aucun article disponible pour le moment.</p>
    <?php else: ?>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Nom</th>
                    <th>Description</th>
                    <th>Prix (€)</th>
                    <th>Vendeur</th>
                    <th>Ajouté le</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($articles as $article): ?>
                <tr>
                    <td><?= htmlspecialchars($article['id']) ?></td>
                    <td><?= htmlspecialchars($article['nom']) ?></td>
                    <td><?= htmlspecialchars($article['description']) ?></td>
                    <td><span class="badge"><?= htmlspecialchars($article['prix']) ?> €</span></td>
                    <td><?= htmlspecialchars($article['vendeur']) ?></td>
                    <td><?= htmlspecialchars($article['created_at']) ?></td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    <?php endif; ?>
</body>
</html>
