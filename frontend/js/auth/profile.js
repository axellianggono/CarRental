const username = document.getElementById('username');
const email = document.getElementById('email');
const date = document.getElementById('date');
const profilePhoto = document.getElementById('profile-photo');

async function fetchProfile() {
    const authToken = localStorage.getItem('auth_token');
    const response = await fetch('../../api/auth/get.php', {
        method: 'GET',
        headers: {
            'Authorization': 'Bearer ' + authToken
        }
    });
    const result = await response.json();
    if (response.ok) {
        username.textContent = result.data.username;
        email.textContent = 'Email: ' + result.data.email;
        date.textContent = 'Date Join: ' + new Date(result.data.created_at).toLocaleDateString();
        profilePhoto.src = '../../api/storage/images/' + result.data.profile_photo;
    } else {
        alert('Failed to fetch profile: ' + result.message);
        if (response.status === 401) {
            window.location.href = 'login.html';
        }
    }
}

window.addEventListener('load', async () => {
    await fetchProfile();
});